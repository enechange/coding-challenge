import React, { useState } from 'react'
import axios from 'axios'
import '../../assets/stylesheets/prices'

export const Prices = () => {
    const [ampere, setAmpere] = useState('')
    const [volume, setVolume] = useState('')
    const [prices, setPrices] = useState([])
    const [errors, setErrors] = useState([])

    const fetch = async ({ ampere, volume }) => {
        try {
            const { data } = await axios.get(`http://localhost:3000/api/prices?ampere=${ampere}&volume=${volume}`)
            setPrices(data)
            setErrors([])
        } catch (e) {
            if (e.response.status === 400) {
                console.log(e.response.data)

                setErrors(e.response.data)
            }

            console.error(e)
        }
    }

    return (
        <div className="container">
            <div className="input-wrapper">
                <label htmlFor="ampere">アンペア</label>
                <input id="ampere" type="numeric" value={ampere} onChange={(e) => setAmpere(e.target.value)} />
                <label htmlFor="volume" value={volume}>
                    使用量
                </label>
                <input id="volume" type="numeric" onChange={(e) => setVolume(e.target.value)} />
            </div>
            {errors.length > 0 && (
                <ul>
                    {errors.map((error) => (
                        <li className="error">{error.message}</li>
                    ))}
                </ul>
            )}

            <button onClick={() => fetch({ ampere, volume })}>結果を見る</button>

            <table border="1">
                <thead>
                    <tr>
                        <th>電力会社</th>
                        <th>プラン名</th>
                        <th>料金(円)</th>
                    </tr>
                </thead>
                <tbody>
                    {errors.length === 0 && (
                        <>
                            {prices?.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.provider_name}</td>
                                    <td>{item.plan_name}</td>
                                    <td>{item.price.toLocaleString()}</td>
                                </tr>
                            ))}
                        </>
                    )}
                </tbody>
            </table>
        </div>
    )
}
